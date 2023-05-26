package com.areastory.user.db.repository;

import com.areastory.user.db.entity.Report;
import com.areastory.user.db.entity.ReportId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReportRepository extends JpaRepository<Report, ReportId> {
}
