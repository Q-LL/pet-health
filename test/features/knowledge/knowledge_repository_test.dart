import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_health/core/knowledge/knowledge_database.dart';
import 'package:pet_health/features/knowledge/data/knowledge_repository.dart';

void main() {
  late KnowledgeDatabase database;
  late KnowledgeRepository repository;

  setUp(() {
    database = KnowledgeDatabase(NativeDatabase.memory());
    repository = KnowledgeRepository(database);
  });

  tearDown(() => database.close());

  test('seeds categories and articles', () async {
    final categories = await repository.listCategories();
    final articles = await repository.findArticles();

    expect(categories, contains('record_guide'));
    expect(categories, contains('daily_care'));
    // 新增分类
    expect(categories, contains('emergency_first_aid'));
    expect(categories, contains('nutrition_diet'));
    expect(categories, contains('skin_coat'));
    expect(categories, contains('behavior_training'));
    // 文章数量已大幅扩充
    expect(articles.length, greaterThanOrEqualTo(50));
  });

  test('searches articles by keyword', () async {
    final articles = await repository.findArticles(keyword: '饮水');

    expect(
      articles.map((article) => article.id),
      contains('observe_water_change'),
    );
  });

  test('finds related articles by context key with sources', () async {
    final articles = await repository.findRelated(contextKey: 'care.oral');

    expect(articles, isNotEmpty);
    expect(articles.first.id, 'care_oral_basics');
    expect(articles.first.sources, isNotEmpty);
  });

  test('findRelated matches precise context key not partial', () async {
    // "care.eye" 应该只匹配包含精确 "care.eye" 的文章
    final eyeArticles = await repository.findRelated(contextKey: 'care.eye');
    expect(eyeArticles, isNotEmpty);
    expect(
      eyeArticles.every((a) => a.contextKeys.contains('care.eye')),
      isTrue,
    );
  });

  test('findRelated returns articles for new emergency category', () async {
    final articles = await repository.findRelated(contextKey: 'vet.emergency');

    expect(articles, isNotEmpty);
    expect(articles.any((a) => a.category == 'emergency_first_aid'), isTrue);
  });

  test('new categories have articles', () async {
    final emergency = await repository.findArticles(
      category: 'emergency_first_aid',
    );
    final nutrition = await repository.findArticles(category: 'nutrition_diet');
    final skin = await repository.findArticles(category: 'skin_coat');
    final behavior = await repository.findArticles(
      category: 'behavior_training',
    );

    expect(emergency.length, greaterThanOrEqualTo(4));
    expect(nutrition.length, greaterThanOrEqualTo(4));
    expect(skin.length, greaterThanOrEqualTo(3));
    expect(behavior.length, greaterThanOrEqualTo(3));
  });

  test('seed articles have correct species and lifeStage', () async {
    final puppyArticle = await repository.getArticle('nutrition_puppy_feeding');
    expect(puppyArticle, isNotNull);
    expect(puppyArticle!.lifeStage, 'puppy');

    final seniorArticle = await repository.getArticle('nutrition_senior_diet');
    expect(seniorArticle, isNotNull);
    expect(seniorArticle!.lifeStage, 'senior');

    final generalArticle = await repository.getArticle('observe_vomiting');
    expect(generalArticle, isNotNull);
    expect(generalArticle!.lifeStage, 'any');
  });
}
