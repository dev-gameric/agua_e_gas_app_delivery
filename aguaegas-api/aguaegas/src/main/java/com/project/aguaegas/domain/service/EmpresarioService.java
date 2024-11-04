package com.project.aguaegas.domain.service;

import com.project.aguaegas.domain.model.Empresario;
import com.project.aguaegas.domain.model.Restaurante;
import com.project.aguaegas.repository.EmpresarioRepository;
import com.project.aguaegas.repository.RestauranteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EmpresarioService {

    @Autowired
    private EmpresarioRepository empresarioRepository;

    @Autowired
    private RestauranteRepository restauranteRepository;

    public Empresario cadastrar(Empresario empresario) {
        return empresarioRepository.save(empresario);
    }

    public List<Empresario> listarTodos() {
        return empresarioRepository.findAll();
    }

    public Empresario buscarPorId(Long id) {
        return empresarioRepository.findById(id).orElse(null);
    }

    public Long buscarRestauranteIdPorEmpresarioId(Long empresarioId) {
        Restaurante restaurante = restauranteRepository.findByEmpresarioId(empresarioId);
        return restaurante != null ? restaurante.getId() : null;
    }
}
