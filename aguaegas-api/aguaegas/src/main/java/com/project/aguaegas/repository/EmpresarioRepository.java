package com.project.aguaegas.repository;

import com.project.aguaegas.domain.model.Empresario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

public interface EmpresarioRepository extends JpaRepository<Empresario, Long> {
    Empresario findByEmail(String email);

}

