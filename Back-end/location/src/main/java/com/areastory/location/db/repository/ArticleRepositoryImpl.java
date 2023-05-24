//package com.areastory.location.db.repository;
//
//
//import com.areastory.location.db.entity.Article;
//import com.areastory.location.dto.common.LocationDto;
//import com.areastory.location.dto.response.LocationResp;
//import lombok.RequiredArgsConstructor;
//import org.springframework.data.domain.Example;
//import org.springframework.data.domain.Page;
//import org.springframework.data.domain.Pageable;
//import org.springframework.data.domain.Sort;
//import org.springframework.data.jpa.repository.Query;
//import org.springframework.data.repository.query.FluentQuery;
//import org.springframework.stereotype.Repository;
//
//import java.util.List;
//import java.util.Optional;
//import java.util.function.Function;
//
//@Repository
//@RequiredArgsConstructor
//public class ArticleRepositoryImpl implements ArticleRepository {
//
//    @Override
//    public List<Article> getDongInfo(String location) {
//        @Query(value = "SELECT * FROM article a " +
//                "JOIN (" +
//                "SELECT dosi, sigungu, dongeupmyeon, MAX(daily_like_count) as max_count" +
//                " FROM article" +
//                " WHERE :loca " +
//                " GROUP BY dosi, sigungu, dongeupmyeon" +
//                ") b ON a.dosi = b.dosi AND a.sigungu = b.sigungu AND a.dongeupmyeon = b.dongeupmyeon AND a.daily_like_count = b.max_count" +
//                "GROUP BY a.dosi, a.sigungu, a.dongeupmyeon", nativeQuery = true)
//
//        return null;
//    }
//
//    @Override
//    public List<LocationResp> getSigunguInfo(String location) {
//        return null;
//    }
//
//    @Override
//    public List<Article> getDosiInfo(String location) {
//        return null;
//    }
//
//    @Override
//    public List<LocationResp> getUserArticleList(Long userId, List<LocationDto> locationList) {
//        return null;
//    }
//
//    @Override
//    public List<LocationResp> getDongeupmyeon() {
//        return null;
//    }
//
//    @Override
//    public List<LocationResp> getSigungu() {
//        return null;
//    }
//
//    @Override
//    public List<LocationResp> getDosi() {
//        return null;
//    }
//
//    @Override
//    public LocationResp getDailyLikeCountData(String type, Long articleId, LocationDto locationDto, Long dailyLikeCount) {
//        return null;
//    }
//
//    @Override
//    public List<Article> findAll() {
//        return null;
//    }
//
//    @Override
//    public List<Article> findAll(Sort sort) {
//        return null;
//    }
//
//    @Override
//    public Page<Article> findAll(Pageable pageable) {
//        return null;
//    }
//
//    @Override
//    public List<Article> findAllById(Iterable<Long> longs) {
//        return null;
//    }
//
//    @Override
//    public long count() {
//        return 0;
//    }
//
//    @Override
//    public void deleteById(Long aLong) {
//
//    }
//
//    @Override
//    public void delete(Article entity) {
//
//    }
//
//    @Override
//    public void deleteAllById(Iterable<? extends Long> longs) {
//
//    }
//
//    @Override
//    public void deleteAll(Iterable<? extends Article> entities) {
//
//    }
//
//    @Override
//    public void deleteAll() {
//
//    }
//
//    @Override
//    public <S extends Article> S save(S entity) {
//        return null;
//    }
//
//    @Override
//    public <S extends Article> List<S> saveAll(Iterable<S> entities) {
//        return null;
//    }
//
//    @Override
//    public Optional<Article> findById(Long aLong) {
//        return Optional.empty();
//    }
//
//    @Override
//    public boolean existsById(Long aLong) {
//        return false;
//    }
//
//    @Override
//    public void flush() {
//
//    }
//
//    @Override
//    public <S extends Article> S saveAndFlush(S entity) {
//        return null;
//    }
//
//    @Override
//    public <S extends Article> List<S> saveAllAndFlush(Iterable<S> entities) {
//        return null;
//    }
//
//    @Override
//    public void deleteAllInBatch(Iterable<Article> entities) {
//
//    }
//
//    @Override
//    public void deleteAllByIdInBatch(Iterable<Long> longs) {
//
//    }
//
//    @Override
//    public void deleteAllInBatch() {
//
//    }
//
//    @Override
//    public Article getOne(Long aLong) {
//        return null;
//    }
//
//    @Override
//    public Article getById(Long aLong) {
//        return null;
//    }
//
//    @Override
//    public Article getReferenceById(Long aLong) {
//        return null;
//    }
//
//    @Override
//    public <S extends Article> Optional<S> findOne(Example<S> example) {
//        return Optional.empty();
//    }
//
//    @Override
//    public <S extends Article> List<S> findAll(Example<S> example) {
//        return null;
//    }
//
//    @Override
//    public <S extends Article> List<S> findAll(Example<S> example, Sort sort) {
//        return null;
//    }
//
//    @Override
//    public <S extends Article> Page<S> findAll(Example<S> example, Pageable pageable) {
//        return null;
//    }
//
//    @Override
//    public <S extends Article> long count(Example<S> example) {
//        return 0;
//    }
//
//    @Override
//    public <S extends Article> boolean exists(Example<S> example) {
//        return false;
//    }
//
//    @Override
//    public <S extends Article, R> R findBy(Example<S> example, Function<FluentQuery.FetchableFluentQuery<S>, R> queryFunction) {
//        return null;
//    }
//}
