package com.project.aguaegas.domain.model;


import com.project.aguaegas.domain.exception.TipoUsuario;
import jakarta.persistence.*;
import lombok.Data;

@Entity
@Data
public class Cliente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String cpf;
    private String email;
    private String senha;
    private String endereco;
    private String telefone;

    @Enumerated(EnumType.STRING)
    private TipoUsuario tipoUsuario;


    public String getPassword() {
        return senha;
    }
}

