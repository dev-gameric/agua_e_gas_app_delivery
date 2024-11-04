package com.project.aguaegas.domain.service;

import com.project.aguaegas.domain.model.Cliente;
import com.project.aguaegas.domain.model.Empresario;
import com.project.aguaegas.domain.model.Restaurante;
import com.project.aguaegas.repository.ClienteRepository;
import com.project.aguaegas.repository.EmpresarioRepository;
import com.project.aguaegas.api.controller.security.JwtTokenProvider;
import com.project.aguaegas.repository.RestauranteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private EmpresarioRepository empresarioRepository;

    @Autowired
    private RestauranteRepository restauranteRepository;

    @Autowired
    private JwtTokenProvider jwtTokenProvider;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public String authenticateUser(String email, String password, String tipoUsuario) {
        if (tipoUsuario.equals("cliente")) {
            Cliente cliente = clienteRepository.findByEmail(email);
            if (cliente != null && passwordEncoder.matches(password, cliente.getPassword())) {
                return jwtTokenProvider.generateToken(email, "CLIENTE", cliente.getId());
            }
        } else if (tipoUsuario.equals("empresario")) {
            Empresario empresario = empresarioRepository.findByEmail(email);
            if (empresario != null && passwordEncoder.matches(password, empresario.getPassword())) {
                // Buscar o restaurante associado ao empresário
                Restaurante restaurante = restauranteRepository.findByEmpresarioId(empresario.getId());
                Long restauranteId = (restaurante != null) ? restaurante.getId() : null; // Garantindo que não seja nulo
                return jwtTokenProvider.generateToken(email, "EMPRESARIO", restauranteId);
            }
        }
        return null; // Credenciais inválidas
    }

    public Long getUserIdFromToken(String token) {
        return jwtTokenProvider.getUserIdFromJWT(token);
    }
}
