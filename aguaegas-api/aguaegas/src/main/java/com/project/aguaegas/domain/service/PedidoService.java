package com.project.aguaegas.domain.service;

import com.project.aguaegas.domain.model.Cliente;
import com.project.aguaegas.domain.model.Pedido;
import com.project.aguaegas.domain.model.Produto;
import com.project.aguaegas.repository.ClienteRepository;
import com.project.aguaegas.repository.PedidoRepository;
import com.project.aguaegas.repository.ProdutoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.project.aguaegas.domain.exception.StatusPedido;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class PedidoService {

    @Autowired
    private PedidoRepository pedidoRepository;
    @Autowired
    private ClienteRepository clienteRepository;
    @Autowired
    private ProdutoRepository produtoRepository;

    public Pedido cadastrar(Pedido pedido) {
        // Busca o cliente e o produto pelos IDs fornecidos
        if (pedido.getCliente() != null && pedido.getCliente().getId() != null) {
            Cliente cliente = clienteRepository.findById(pedido.getCliente().getId()).orElse(null);
            pedido.setCliente(cliente);
        }
        if (pedido.getProduto() != null && pedido.getProduto().getId() != null) {
            Produto produto = produtoRepository.findById(pedido.getProduto().getId()).orElse(null);
            pedido.setProduto(produto);
        }

        // Define a data e o status do pedido
        pedido.setDataPedido(LocalDateTime.now());
        pedido.setStatusPedido(StatusPedido.CONCLUIDO);

        return pedidoRepository.save(pedido);
    }

    public List<Pedido> listarTodos() {
        return pedidoRepository.findAll();
    }

    public Pedido buscarPorId(Long id) {
        return pedidoRepository.findById(id).orElse(null);
    }
}
