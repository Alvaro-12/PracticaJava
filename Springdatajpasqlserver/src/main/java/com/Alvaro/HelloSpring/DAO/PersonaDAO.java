 package com.Alvaro.HelloSpring.DAO;

import org.springframework.data.repository.CrudRepository;

import com.Alvaro.HelloSpring.entidades.Persona;

public interface PersonaDAO extends CrudRepository<Persona, Long> {
	
	

}
