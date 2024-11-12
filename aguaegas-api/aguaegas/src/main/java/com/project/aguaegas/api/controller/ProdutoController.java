package com.project.aguaegas.api.controller;

import com.project.aguaegas.domain.model.Produto;
import com.project.aguaegas.domain.service.ProdutoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(value = "/produto", produces = "application/json;charset=UTF-8")
public class ProdutoController {

    @Autowired
    private ProdutoService produtoService;

    @PostMapping
    public ResponseEntity<Produto> cadastrarProduto(@RequestBody Produto produto) {
        // Você pode adicionar uma verificação se o restaurante existe aqui
        if (produto.getRestaurante() == null || produto.getRestaurante().getId() == null) {
            return ResponseEntity.badRequest().body(null);
        }
        Produto novoProduto = produtoService.cadastrar(produto);
        return ResponseEntity.ok(novoProduto);
    }


    @GetMapping
    public ResponseEntity<List<Produto>> listarTodos() {
        List<Produto> produtos = produtoService.listarTodos();
        return ResponseEntity.ok(produtos);
    }


}


