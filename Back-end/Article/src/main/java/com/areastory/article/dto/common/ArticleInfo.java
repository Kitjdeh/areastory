package com.areastory.article.dto.common;

import com.querydsl.core.annotations.QueryProjection;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@NoArgsConstructor
@Getter
@Setter
public class ArticleInfo {
    private Long articleId;
    private List<CommentInfo> commentList = new ArrayList<>();

    @QueryProjection
    public ArticleInfo(Long articleId, List<CommentInfo> commentList) {
        this.articleId = articleId;
        this.commentList = commentList;
    }


    @Getter
    @Setter
    public static class CommentInfo {
        private Long commentId;
        private Long articleId;
        private String nickname;
        private String profile;
        private String content;
        private Long likeCount;

        @QueryProjection
        public CommentInfo(Long commentId, Long articleId, String nickname, String profile, String content, Long likeCount) {
            this.commentId = commentId;
            this.articleId = articleId;
            this.nickname = nickname;
            this.profile = profile;
            this.content = content;
            this.likeCount = likeCount;
        }
    }
}
