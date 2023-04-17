package com.areastory.article.db.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@Entity
@Getter
@NoArgsConstructor
public class Location {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long locationId;

    @Column(name ="do")
    private String doName;
    private String si;
    private String gun;
    private String gu;
    private String dong;
    private String eup;
    private String myeon;
}
