package com.project.aguaegas.domain.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Restaurante {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "empresario_id", nullable = false)
    private Empresario empresario;

    private String nomeFantasia;
    private String cnpj;
    private String endereco;
    private String telefone;
    private String descricao;
    private String photoUrl;


    // Getters e setters
}

