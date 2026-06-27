import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/knowledge/knowledge_database.dart' as db;
import '../domain/knowledge_article.dart';

final knowledgeDatabaseProvider = Provider<db.KnowledgeDatabase>((ref) {
  final database = db.KnowledgeDatabase.defaults();
  ref.onDispose(database.close);
  return database;
});

final knowledgeRepositoryProvider = Provider<KnowledgeRepository>((ref) {
  return KnowledgeRepository(ref.watch(knowledgeDatabaseProvider));
});

final knowledgeCategoriesProvider = FutureProvider<List<String>>((ref) {
  return ref.watch(knowledgeRepositoryProvider).listCategories();
});

final knowledgeArticleProvider = FutureProvider.autoDispose
    .family<KnowledgeArticle?, String>((ref, id) {
      return ref.watch(knowledgeRepositoryProvider).getArticle(id);
    });

final relatedKnowledgeProvider = FutureProvider.autoDispose
    .family<List<KnowledgeArticle>, String>((ref, contextKey) {
      return ref
          .watch(knowledgeRepositoryProvider)
          .findRelated(contextKey: contextKey, limit: 2);
    });

class KnowledgeQuery {
  const KnowledgeQuery({this.category, this.keyword = ''});

  final String? category;
  final String keyword;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KnowledgeQuery &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          keyword == other.keyword;

  @override
  int get hashCode => Object.hash(category, keyword);
}

final knowledgeArticlesProvider = FutureProvider.autoDispose
    .family<List<KnowledgeArticle>, KnowledgeQuery>((ref, query) {
      return ref
          .watch(knowledgeRepositoryProvider)
          .findArticles(category: query.category, keyword: query.keyword);
    });

class KnowledgeRepository {
  const KnowledgeRepository(this._database);

  final db.KnowledgeDatabase _database;

  Future<List<String>> listCategories() async {
    final rows =
        await (_database.selectOnly(_database.knowledgeArticles, distinct: true)
              ..addColumns([_database.knowledgeArticles.category]))
            .map((row) => row.read(_database.knowledgeArticles.category))
            .get();
    final categories = rows.whereType<String>().toList();
    categories.sort((a, b) {
      final labels = knowledgeCategories.keys.toList();
      return labels.indexOf(a).compareTo(labels.indexOf(b));
    });
    return categories;
  }

  Future<List<KnowledgeArticle>> findArticles({
    String? category,
    String keyword = '',
    int limit = 80,
  }) async {
    final query = _database.select(_database.knowledgeArticles)
      ..orderBy([
        (article) => OrderingTerm.asc(article.category),
        (article) => OrderingTerm.asc(article.title),
      ])
      ..limit(limit);

    final trimmed = keyword.trim();
    query.where((article) {
      Expression<bool> expression = const Constant(true);
      if (category != null && category.isNotEmpty) {
        expression = expression & article.category.equals(category);
      }
      if (trimmed.isNotEmpty) {
        final pattern = '%$trimmed%';
        expression =
            expression &
            (article.title.like(pattern) |
                article.summary.like(pattern) |
                article.body.like(pattern) |
                article.tagsJson.like(pattern));
      }
      return expression;
    });

    final rows = await query.get();
    return Future.wait(rows.map(_articleFromRow));
  }

  Future<KnowledgeArticle?> getArticle(String id) async {
    final row = await (_database.select(
      _database.knowledgeArticles,
    )..where((article) => article.id.equals(id))).getSingleOrNull();
    return row == null ? null : _articleFromRow(row);
  }

  Future<List<KnowledgeArticle>> findRelated({
    required String contextKey,
    int limit = 3,
  }) async {
    // 使用更精确的 JSON 数组匹配模式，避免部分 key 匹配。
    // 例如 "care.eye" 不会错误匹配 "care.eyecare"。
    final p1 = '%"$contextKey",%'; // key 后跟逗号（数组中间）
    final p2 = '%["$contextKey"%'; // 数组第一个元素
    final p3 = '%"$contextKey"]%'; // 数组最后一个元素
    final rows =
        await (_database.select(_database.knowledgeArticles)
              ..where(
                (article) =>
                    article.contextKeysJson.like(p1) |
                    article.contextKeysJson.like(p2) |
                    article.contextKeysJson.like(p3),
              )
              ..orderBy([
                (a) => OrderingTerm.asc(a.severityLevel),
                (a) => OrderingTerm.asc(a.title),
              ])
              ..limit(limit))
            .get();
    return Future.wait(rows.map(_articleFromRow));
  }

  Future<List<KnowledgeSource>> sourcesForArticle(String articleId) async {
    final source = _database.knowledgeSources;
    final joinRows =
        await (_database.select(_database.knowledgeArticleSources).join([
              innerJoin(
                source,
                source.id.equalsExp(_database.knowledgeArticleSources.sourceId),
              ),
            ])..where(
              _database.knowledgeArticleSources.articleId.equals(articleId),
            ))
            .get();

    return joinRows
        .map((row) => _sourceFromRow(row.readTable(source)))
        .toList(growable: false);
  }

  Future<KnowledgeArticle> _articleFromRow(db.KnowledgeArticle row) async {
    return KnowledgeArticle(
      id: row.id,
      title: row.title,
      category: row.category,
      summary: row.summary,
      body: row.body,
      severityLevel: row.severityLevel,
      species: row.species,
      lifeStage: row.lifeStage,
      contextKeys: _decodeStringList(row.contextKeysJson),
      tags: _decodeStringList(row.tagsJson),
      redFlags: _decodeStringList(row.redFlagsJson),
      suggestedActions: _decodeStringList(row.suggestedActionsJson),
      reviewedStatus: row.reviewedStatus,
      version: row.version,
      updatedAt: row.updatedAt,
      sources: await sourcesForArticle(row.id),
    );
  }

  KnowledgeSource _sourceFromRow(db.KnowledgeSource row) {
    return KnowledgeSource(
      id: row.id,
      title: row.title,
      organization: row.organization,
      url: row.url,
      licenseNote: row.licenseNote,
      accessedAt: row.accessedAt,
    );
  }
}

List<String> _decodeStringList(String raw) {
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded.map((item) => item.toString()).toList(growable: false);
  } on FormatException {
    return const [];
  }
}
