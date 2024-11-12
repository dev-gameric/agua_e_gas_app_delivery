package com.project.aguaegas.api.controller;

import com.project.aguaegas.domain.model.Empresario;
import com.project.aguaegas.domain.model.Produto;
import com.project.aguaegas.domain.model.Restaurante;
import com.project.aguaegas.domain.service.EmpresarioService;
import com.project.aguaegas.domain.service.RestauranteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/restaurantes", produces = "application/json;charset=UTF-8")
public class RestauranteController {

    @Autowired
    private RestauranteService restauranteService;

    @Autowired
    private EmpresarioService empresarioService;

    @GetMapping("/listar")
    public List<Restaurante> listarRestaurantes() {
        return restauranteService.listarRestaurantes();
    }

    @GetMapping("/{id}/produtos")
    public List<Produto> listarProdutosPorRestaurante(@PathVariable Long id) {
        return restauranteService.listarProdutosPorRestaurante(id);
    }

    @PostMapping("/cadastrar")
    public ResponseEntity<Restaurante> cadastrarRestaurante(@RequestBody Restaurante restaurante, @RequestParam Long empresarioId) {
        Restaurante novoRestaurante = restauranteService.cadastrarRestaurante(restaurante, empresarioId);
        return ResponseEntity.status(HttpStatus.CREATED).body(novoRestaurante);
    }


}

