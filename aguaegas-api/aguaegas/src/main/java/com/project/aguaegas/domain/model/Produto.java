package com.project.aguaegas.domain.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Produto {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private Double preco;
    private String descricao;
    private String categoria;
    private String photoUrl;
    private Integer quantidadeEstoque;

    @ManyToOne
    @JoinColumn(name = "restaurante_id")
    private Restaurante restaurante;
}
