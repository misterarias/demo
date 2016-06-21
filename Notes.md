
## Despliegues portables entre máquinas.

Docker define un formato para empaquetar aplicaciones y todas sus dependencias en un único objeto que puede ser transferido a cualquier máquina dockerizada. 

## Orientado a la ejecución de aplicaciones.
  
Docker está optimizado para el despliegue de aplicaciones, no de máqinas.

## Construccion automática.
 
Docker proporciona la capacidad de que los desarrolladores puedan ensamblar containers para su código fuente con control absoluto sobre las dependencias de la aplicación, herramientas de construcción, métodos de enpaquetamiento, etc...

## Versionamiento.
  
Docker incluye un mecanismos similar al de git para el seguimiento de las sucesivas versiones de un container. 

## Reutilización de componentes.

Cualquier container puede ser usado como una imagen base para crear componentes mas especializados. 

## Compartible.
  
Docker tiene accesos a un registro público donde muchas personas han subido containers muy útiles: redis, couchdb, postgress, rails, servidores, diferentes distribuciones...

## Ecosistema de herramientas.
  
Docker define un API para la automatizar y configurar la creación y despliegue de contenedores.

- Herramientas para el despliegue: Dokku, Deis, Flynn... 
- Orquestación multi-nodo: maestro, salt, mesos, openstack nova...
- Tableros de mando de gestión: docker-ui, openstack horizon, shipyard...
- Gestión de la configuración: chef, puppet
- Integración continua: jenkins, strider, travis
