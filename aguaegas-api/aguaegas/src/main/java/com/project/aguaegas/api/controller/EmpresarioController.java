package com.project.aguaegas.api.controller;

import com.project.aguaegas.domain.exception.TipoUsuario;
import com.project.aguaegas.domain.model.Empresario;
import com.project.aguaegas.domain.service.EmpresarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/empresario")
public class EmpresarioController {

    @Autowired
    private EmpresarioService empresarioService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping
    public ResponseEntity<Empresario> cadastrarEmpresario(@RequestBody Empresario empresario) {
        // Codificando a senha antes de cadastrar
        empresario.setSenha(passwordEncoder.encode(empresario.getPassword()));
        empresario.setTipoUsuario(TipoUsuario.EMPRESARIO);
        Empresario novoEmpresario = empresarioService.cadastrar(empresario);
        return ResponseEntity
                .created(URI.create("/empresario/" + novoEmpresario.getId()))
                .body(novoEmpresario);
    }

    @GetMapping
    public ResponseEntity<List<Empresario>> listarTodos() {
        List<Empresario> empresarios = empresarioService.listarTodos();
        return ResponseEntity.ok(empresarios);
    }
}
