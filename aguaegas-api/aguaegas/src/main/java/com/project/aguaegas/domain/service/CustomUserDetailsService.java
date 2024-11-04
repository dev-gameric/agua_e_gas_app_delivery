package com.project.aguaegas.domain.service;

import com.project.aguaegas.domain.model.Cliente;
import com.project.aguaegas.domain.model.CustomUserDetails;
import com.project.aguaegas.domain.model.Empresario;
import com.project.aguaegas.repository.ClienteRepository;
import com.project.aguaegas.repository.EmpresarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {
    @Autowired
    private ClienteRepository clienteRepository;
    @Autowired
    private EmpresarioRepository empresarioRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        Cliente cliente = clienteRepository.findByEmail(username);
        if (cliente != null) {
            return new CustomUserDetails(cliente.getEmail(), cliente.getSenha(), "ROLE_CLIENTE");
        }

        Empresario empresario = empresarioRepository.findByEmail(username);
        if (empresario != null) {
            return new CustomUserDetails(empresario.getEmail(), empresario.getSenha(), "ROLE_EMPRESARIO");
        }

        throw new UsernameNotFoundException("Usuário não encontrado");
    }
}

