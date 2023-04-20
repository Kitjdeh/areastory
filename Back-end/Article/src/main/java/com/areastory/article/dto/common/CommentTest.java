package com.areastory.article.dto.common;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@Getter
@Setter
public class CommentTest {
    private Long commentId;
    private String content;
    private String nickname;
    private Long likeCount;
    private boolean isLike;

    public CommentTest(Long commentId, String content, String nickname, Long likeCount, boolean isLike) {
        this.commentId = commentId;
        this.content = content;
        this.nickname = nickname;
        this.likeCount = likeCount;
        this.isLike = isLike;
    }
}
