package com.project.aguaegas.repository;

import com.project.aguaegas.domain.model.Produto;
import org.springframework.data.jpa.repository.JpaRepository;


import java.util.List;

public interface ProdutoRepository extends JpaRepository<Produto, Long> {
    List<Produto> findByRestauranteId(Long restauranteId);
}
