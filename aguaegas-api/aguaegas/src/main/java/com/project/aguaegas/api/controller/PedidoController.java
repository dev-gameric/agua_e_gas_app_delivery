package com.project.aguaegas.api.controller;

import com.project.aguaegas.domain.model.Pedido;
import com.project.aguaegas.domain.service.PedidoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.project.aguaegas.repository.PedidoRepository;

import java.util.List;

@RestController
@RequestMapping(value = "/pedido", produces = "application/json;charset=UTF-8")
public class PedidoController {

    @Autowired
    private PedidoService pedidoService;

    @Autowired
    private PedidoRepository pedidoRepository;

    @PostMapping
    public ResponseEntity<Pedido> cadastrarPedido(@RequestBody Pedido pedido) {
        Pedido novoPedido = pedidoService.cadastrar(pedido);
        return ResponseEntity.ok(novoPedido);
    }

    @GetMapping
    public ResponseEntity<List<Pedido>> listarTodos() {
        List<Pedido> pedidos = pedidoService.listarTodos();
        return ResponseEntity.ok(pedidos);
    }

    @GetMapping("/pedidos")
    public ResponseEntity<List<Pedido>> listarPedidos(@RequestParam Long restauranteId) {
        List<Pedido> pedidos = pedidoRepository.findByProduto_RestauranteId(restauranteId);
        return ResponseEntity.ok(pedidos);
    }

}


