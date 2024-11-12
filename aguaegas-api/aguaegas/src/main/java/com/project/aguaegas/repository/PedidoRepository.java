package com.project.aguaegas.repository;

import com.project.aguaegas.domain.model.Pedido;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PedidoRepository extends JpaRepository<Pedido, Long> {
    @Query("SELECT p FROM Pedido p WHERE p.produto.restaurante.id = :restauranteId")
    List<Pedido> findByProduto_RestauranteId(@Param("restauranteId") Long restauranteId);
}

