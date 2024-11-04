package com.project.aguaegas.repository;

import com.project.aguaegas.domain.model.Restaurante;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RestauranteRepository extends JpaRepository<Restaurante, Long> {
    Restaurante findByEmpresarioId(Long empresarioId);
}

