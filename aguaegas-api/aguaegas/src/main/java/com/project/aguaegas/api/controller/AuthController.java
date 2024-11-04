package com.project.aguaegas.api.controller;

import com.project.aguaegas.domain.service.AuthService;
import com.project.aguaegas.domain.service.EmpresarioService;
import com.project.aguaegas.repository.ClienteRepository;
import com.project.aguaegas.repository.EmpresarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @Autowired
    private ClienteRepository clienteRepository;

    @Autowired
    private EmpresarioService empresarioService;

    @Autowired
    private EmpresarioRepository empresarioRepository;

    @PostMapping("/login/cliente")
    public ResponseEntity<?> authenticateCliente(@RequestBody Map<String, String> credentials) {
        return authenticateUser(credentials, "cliente");
    }

    @PostMapping("/login/empresario")
    public ResponseEntity<?> authenticateEmpresario(@RequestBody Map<String, String> credentials) {
        return authenticateUser(credentials, "empresario");
    }

    private ResponseEntity<?> authenticateUser(Map<String, String> credentials, String tipoUsuario) {
        String email = credentials.get("email");
        String password = credentials.get("password");
        String token = authService.authenticateUser(email, password, tipoUsuario);

        if (token != null) {
            Long userId;
            Long restauranteId = null; // Inicializa como null

            if (tipoUsuario.equals("cliente")) {
                userId = clienteRepository.findByEmail(email).getId();
                // Não precisa definir restauranteId, já que não é aplicável para clientes
            } else {
                // Para empresário, obtenha o ID do restaurante associado
                Long empresarioId = empresarioRepository.findByEmail(email).getId();
                restauranteId = empresarioService.buscarRestauranteIdPorEmpresarioId(empresarioId);
                userId = empresarioId; // Retornando o ID do empresário
            }

            // Retorna tanto o userId quanto o restauranteId se disponível
            if ("cliente".equals(tipoUsuario)) {
                return ResponseEntity.ok(Map.of("token", token, "userId", userId, "TipoUsuario", tipoUsuario));
            } else {
                return ResponseEntity.ok(Map.of("token", token, "userId", userId, "restauranteId", restauranteId, "TipoUsuario", tipoUsuario));
            }
        } else {
            return ResponseEntity.status(401).body(Map.of("message", "Invalid credentials"));
        }
    }
}
