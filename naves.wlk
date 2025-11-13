class Nave {
    var velocidad
    var direccionAlSol = 0
    var combustible 

    method cargarCombustible(cuanto){
        combustible += cuanto
    }

    method descargarCombustible(cuanto){
        combustible = (combustible - cuanto).max(0)
    }

    method acelerar(cuanto){
        velocidad = (velocidad + cuanto).min(100000)
    }

    method desacelerar(cuanto){
        velocidad = (velocidad - cuanto).max(0)
    }

    method irHaciaElSol() {direccionAlSol = 10}
    method escaparDelSol() {direccionAlSol = -10}
    method paraleloAlSol() {direccionAlSol = 0}

    method acercarseUnPocoAlSol(){
        direccionAlSol = (direccionAlSol + 1).min(10)
    }

    method alejarseUnPocoDelSol(){
        direccionAlSol = (direccionAlSol - 1).max(-10)
    }

    method prepararViaje() {
        self.cargarCombustible(30000)
        self.acelerar(5000)
        self.accionAdicional()
    }

    method accionAdicional()

    method estaTranquila(){
        return
        combustible >= 4000 && 
        velocidad <= 12000
        self.condicionAdicional()
    }

    method condicionAdicional()

    method recibirAmenaza(){
        self.escapar()
        self.avisar()
    }

    method escapar()
    method avisar()

    method estaDeRelajo(){
        return
        self.estaTranquila() &&
        self.tienePocaActividad()
    }

    method tienePocaActividad()
}

class NaveBaliza inherits Nave {
    var colorBaliza = "verde"
    var cambioBaliza = false

    method cambiarColorBaliza(colorNuevo){
        colorBaliza = colorNuevo
        cambioBaliza = true
    }

    override method accionAdicional(){
        self.cambiarColorBaliza("verde")
        self.paraleloAlSol()
    }

    override method condicionAdicional(){
        return
        colorBaliza != "rojo"
    }

    override method escapar() {
        self.irHaciaElSol()
        }
    override method avisar() {
        self.cambiarColorBaliza("rojo")
    }

    override method tienePocaActividad() = not cambioBaliza
}

class NavePasajeros inherits Nave {
    const pasajeros
    var comida = 0
    var bebida = 0
    var cantComidaServida = 0

    method cargar(cantBebida, cantComida){
        bebida += cantBebida
        comida += cantComida
    }

    method descargar(cantBebida, cantComida){
        bebida = (bebida - cantBebida).max(0)
        comida = (comida - cantComida).max(0)
        cantComidaServida += cantComida
    }

    override method accionAdicional(){
        self.cargar(6*pasajeros, 4*pasajeros)
        self.acercarseUnPocoAlSol()
    }

    override method condicionAdicional() {
        return true
    }

    override method escapar() {
        self.acelerar(velocidad)
    }
    override method avisar() {
        self.descargar(pasajeros*2, pasajeros)
    }

    override method tienePocaActividad() = cantComidaServida < 50
}

class NaveCombate inherits Nave {
    var invisible = true
    var misilesDesplegados = false
    const mensajes = []

    method ponerseVisible() {invisible = true}
    method ponerseInvisible() {invisible = false}
    method  estaInvisble() = invisible
    method desplegarMisiles() {misilesDesplegados = true}
    method replegarMisiles() {misilesDesplegados = false}
    method misilesDesplegados() = misilesDesplegados

    method emitirMensaje(mensaje){
        mensajes.add(mensaje)
    }
    method mensajesEmitidos() = mensajes
    method cantMensajesEmitidos() = mensajes.size()
    method primerMensajeEmitido() { 
        if(mensajes.isEmpty()) {
            self.error("Aun no hay mensajes emitidos")
        }
        return mensajes.first()
    }
    method ultimoMensajeEmitido() { 
        if(mensajes.isEmpty()) {
            self.error("Aun no hay mensajes emitidos")
        }
        return mensajes.last()
    }
    method esEscueta(){
        return mensajes.all({m => m.length() < 30})
    }

    method emitioMensaje(mensaje){
        return mensajes.contains(mensaje)
    }

    override method accionAdicional(){
        self.ponerseVisible()
        self.replegarMisiles()
        self.acelerar(15000)
        self.emitirMensaje("Saliendo en misión")
    }

    override method condicionAdicional() {
        return
        ! misilesDesplegados
    }

    override method escapar() {
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }
    override method avisar() {
        self.emitirMensaje("Amenaza recibida")
    }

    override method tienePocaActividad() = true
}

class NaveHospital inherits NavePasajeros {
    var quirofanosPreparados = false

    method prepararQuirofanos() {quirofanosPreparados = true}

    override method condicionAdicional() {
        return not quirofanosPreparados
    }

    override method recibirAmenaza(){
        super()
        self.prepararQuirofanos()
    }

    override method tienePocaActividad() = true
}

class NaveSigilosa inherits NaveCombate {
    override method condicionAdicional() {
        return super() && not self.estaInvisble()
    }

    override method escapar(){
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }   
}

