package com.project.aguaegas.domain.model;

import com.project.aguaegas.domain.exception.TipoUsuario;
import jakarta.persistence.*;
import lombok.Data;
import org.hibernate.usertype.UserType;


@Entity
@Data
public class Empresario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nome;
    private String email;
    private String senha;

    @Enumerated(EnumType.STRING)
    private TipoUsuario tipoUsuario;

    public String getPassword() {
        return senha;
    }
}

