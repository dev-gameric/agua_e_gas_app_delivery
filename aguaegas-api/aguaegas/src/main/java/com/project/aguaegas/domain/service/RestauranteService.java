package com.project.aguaegas.domain.service;

import com.project.aguaegas.domain.model.Empresario;
import com.project.aguaegas.domain.model.Produto;
import com.project.aguaegas.domain.model.Restaurante;
import com.project.aguaegas.repository.EmpresarioRepository;
import com.project.aguaegas.repository.ProdutoRepository;
import com.project.aguaegas.repository.RestauranteRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class RestauranteService {
    @Autowired
    private RestauranteRepository restauranteRepository;

    @Autowired
    private ProdutoRepository produtoRepository;

    @Autowired
    private EmpresarioRepository empresarioRepository;

    public List<Restaurante> listarRestaurantes() {
        return restauranteRepository.findAll();
    }

    public List<Produto> listarProdutosPorRestaurante(Long restauranteId) {
        return produtoRepository.findByRestauranteId(restauranteId);
    }

    public Long obterRestauranteIdPorEmpresarioId(Long empresarioId) {
        // Busca o restaurante associado ao empresário
        Restaurante restaurante = restauranteRepository.findByEmpresarioId(empresarioId);
        return restaurante != null ? restaurante.getId() : null; // Retorna o ID do restaurante
    }


    public Restaurante cadastrarRestaurante(Restaurante restaurante, Long empresarioId) {
        // Verifica se o empresário existe
        Optional<Empresario> empresario = empresarioRepository.findById(empresarioId);
        if (empresario.isPresent()) {
            restaurante.setEmpresario(empresario.get()); // Atribui o empresário ao restaurante
            return restauranteRepository.save(restaurante); // Salva o restaurante
        } else {
            throw new EntityNotFoundException("Empresário não encontrado");
        }
    }
}

