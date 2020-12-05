package com.Alvaro.HelloSpring.Controlador;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;

import com.Alvaro.HelloSpring.DAO.PersonaDAO;

public class ControladorInicio {

	@Autowired
	private PersonaDAO perDAO;
	
  @GetMapping("/")	
  public String Inicio () {
	 
	  var MostrarPersonas = perDAO.findAll();
	  
	  for (var iteracion: MostrarPersonas)
	  System.out.print(interacion.getNombre());
	  
	  
	 return "NewFile";  
  }
	
	
}
