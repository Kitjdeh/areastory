//package com.areastory.location.api.service.impl;
//
//import com.areastory.location.db.entity.Article;
//import com.areastory.location.db.entity.Location;
//import com.areastory.location.db.repository.ArticleRepository;
//import com.areastory.location.dto.common.LocationDto;
//import com.areastory.location.dto.response.LocationResp;
//import com.areastory.location.service.LocationService;
//import org.junit.jupiter.api.*;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//
//import java.util.ArrayList;
//import java.util.Comparator;
//import java.util.List;
//
//import static org.junit.jupiter.api.Assertions.assertEquals;
//import static org.junit.jupiter.api.Assertions.assertNull;
//
//@SpringBootTest
//@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
//public class LocationServiceImplTest {
//    static List<Article> articleList;
//    static List<Location> locationList;
//    @Autowired
//    LocationService locationService;
//
//    @BeforeAll
//    static void setup(@Autowired ArticleRepository articleRepository) {
//        locationList = new ArrayList<>();
//        locationList.add(Location.builder()
//                .doName("경기도")
//                .si("고양시")
//                .gu("일산동구")
//                .build()
//        );
//        locationList.add(Location.builder()
//                .doName("경기도")
//                .si("고양시")
//                .gu("덕양구")
//                .build()
//        );
//        locationList.add(Location.builder()
//                .doName("경기도")
//                .si("고양시")
//                .gu("일산서구")
//                .build()
//        );
//        locationList.add(Location.builder()
//                .si("서울특별시")
//                .gu("성동구")
//                .dong("응봉동")
//                .build()
//        );
//        locationList.add(Location.builder()
//                .si("서울특별시")
//                .gu("성동구")
//                .dong("용답동")
//                .build()
//        );
//        locationList.add(Location.builder()
//                .si("서울특별시")
//                .gu("성동구")
//                .dong("송정동")
//                .build()
//        );
//        articleList = new ArrayList<>();
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(0))
//                .image("1번사진")
//                .likeCount(6L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(0))
//                .image("2번사진")
//                .likeCount(8L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(0))
//                .image("3번사진")
//                .likeCount(4L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(1))
//                .image("4번사진")
//                .likeCount(3L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(1))
//                .image("5번사진")
//                .likeCount(4L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(1))
//                .image("6번사진")
//                .likeCount(2L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(2))
//                .image("7번사진")
//                .likeCount(3L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(2))
//                .image("8번사진")
//                .likeCount(4L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(2))
//                .image("9번사진")
//                .likeCount(2L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(3))
//                .image("10번사진")
//                .likeCount(3L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(3))
//                .image("11번사진")
//                .likeCount(4L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(3))
//                .image("12번사진")
//                .likeCount(2L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(4))
//                .image("13번사진")
//                .likeCount(3L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(4))
//                .image("14번사진")
//                .likeCount(4L)
//                .userId(2L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(4))
//                .image("15번사진")
//                .likeCount(2L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(5))
//                .image("16번사진")
//                .likeCount(3L)
//                .userId(1L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(5))
//                .image("17번사진")
//                .likeCount(4L)
//                .userId(3L)
//                .build());
//        articleList.add(Article.articleBuilder()
//                .location(locationList.get(5))
//                .image("18번사진")
//                .likeCount(2L)
//                .userId(1L)
//                .build());
//        articleList = articleRepository.saveAll(articleList);
//    }
//
//    @Test
//    @Order(1)
//    @DisplayName("전체 맵 불러오기")
//    void getMapImages() throws Exception {
//
//        //when
//        List<LocationDto> locationListTestSmall = new ArrayList<>();
//        locationListTestSmall.add(LocationDto.builder()
//                .doName("경기도")
//                .si("고양시")
//                .gu("덕양구")
//                .build()
//        );
//        locationListTestSmall.add(LocationDto.builder()
//                .doName("경기도")
//                .si("고양시")
//                .gu("일산서구")
//                .build()
//        );
//        List<LocationDto> locationListTestBig = new ArrayList<>();
//        locationListTestBig.add(LocationDto.builder()
//                .doName("경기도")
//                .si("고양시")
//                .build()
//        );
//        locationListTestBig.add(LocationDto.builder()
//                .si("서울특별시")
//                .build()
//        );
//        //then
//        List<LocationResp> mapImages = locationService.getMapImages(locationListTestSmall);
//        assertEquals(2, mapImages.size());
//        mapImages.sort((o1, o2) -> Math.toIntExact(o1.getArticleId() - o2.getArticleId()));
//        assertEquals("5번사진", mapImages.get(0).getImage());
//        assertEquals("덕양구", mapImages.get(0).getLocationDto().getGu());
//
//        assertEquals("8번사진", mapImages.get(1).getImage());
//        assertEquals("일산서구", mapImages.get(1).getLocationDto().getGu());
//        mapImages = locationService.getMapImages(locationListTestBig);
//        assertEquals(2, mapImages.size());
//        mapImages.sort((o1, o2) -> Math.toIntExact(o1.getArticleId() - o2.getArticleId()));
//        assertEquals("2번사진", mapImages.get(0).getImage());
//        assertEquals("경기도", mapImages.get(0).getLocationDto().getDoName());
//        assertEquals("고양시", mapImages.get(0).getLocationDto().getSi());
//        assertNull(mapImages.get(0).getLocationDto().getGu());
//
//        assertEquals("11번사진", mapImages.get(1).getImage());
//        assertEquals("서울특별시", mapImages.get(1).getLocationDto().getSi());
//        assertNull(mapImages.get(1).getLocationDto().getGu());
//        assertNull(mapImages.get(1).getLocationDto().getDong());
//    }
//
//    @Test
//    @Order(2)
//    @DisplayName("유저 맵 불러오기")
//    void getUserMapImages() throws Exception {
//        List<LocationDto> locationListTestSmall = new ArrayList<>();
//        locationListTestSmall.add(LocationDto.builder()
//                .doName("경기도")
//                .si("고양시")
//                .gu("덕양구")
//                .build()
//        );
//        locationListTestSmall.add(LocationDto.builder()
//                .doName("경기도")
//                .si("고양시")
//                .gu("일산서구")
//                .build()
//        );
//        List<LocationDto> locationListTestBig = new ArrayList<>();
//        locationListTestBig.add(LocationDto.builder()
//                .doName("경기도")
//                .si("고양시")
//                .build()
//        );
//        locationListTestBig.add(LocationDto.builder()
//                .si("서울특별시")
//                .build()
//        );
//        List<LocationResp> mapImages = locationService.getUserMapImages(1L, locationListTestSmall);
//        assertEquals(2, mapImages.size());
//        mapImages.sort((o1, o2) -> Math.toIntExact(o1.getArticleId() - o2.getArticleId()));
//        assertEquals("5번사진", mapImages.get(0).getImage());
//        assertEquals("덕양구", mapImages.get(0).getLocationDto().getGu());
//        assertEquals("8번사진", mapImages.get(1).getImage());
//        assertEquals("일산서구", mapImages.get(1).getLocationDto().getGu());
//
//        mapImages = locationService.getUserMapImages(2L, locationListTestSmall);
//        mapImages.sort(Comparator.comparing(o -> o.getLocationDto().getGu()));
//        assertEquals(2, mapImages.size());
//        assertNull(mapImages.get(0).getImage());
//        assertEquals("덕양구", mapImages.get(0).getLocationDto().getGu());
//        assertNull(mapImages.get(1).getImage());
//        assertEquals("일산서구", mapImages.get(1).getLocationDto().getGu());
//
//        mapImages = locationService.getUserMapImages(1L, locationListTestBig);
//        mapImages.sort((o1, o2) -> Math.toIntExact(o1.getArticleId() - o2.getArticleId()));
//        assertEquals("2번사진", mapImages.get(0).getImage());
//        assertEquals("경기도", mapImages.get(0).getLocationDto().getDoName());
//        assertEquals("고양시", mapImages.get(0).getLocationDto().getSi());
//        assertNull(mapImages.get(0).getLocationDto().getGu());
//
//        assertEquals("11번사진", mapImages.get(1).getImage());
//        assertEquals("서울특별시", mapImages.get(1).getLocationDto().getSi());
//        assertNull(mapImages.get(1).getLocationDto().getGu());
//        assertNull(mapImages.get(1).getLocationDto().getDong());
//
//        mapImages = locationService.getUserMapImages(2L, locationListTestBig);
//        mapImages.sort(Comparator.comparing(o -> o.getLocationDto().getSi()));
//        assertNull(mapImages.get(0).getImage());
//        assertEquals("경기도", mapImages.get(0).getLocationDto().getDoName());
//        assertEquals("고양시", mapImages.get(0).getLocationDto().getSi());
//        assertNull(mapImages.get(0).getLocationDto().getGu());
//
//        assertEquals("14번사진", mapImages.get(1).getImage());
//        assertEquals("서울특별시", mapImages.get(1).getLocationDto().getSi());
//        assertNull(mapImages.get(1).getLocationDto().getGu());
//        assertNull(mapImages.get(1).getLocationDto().getDong());
//    }
//}