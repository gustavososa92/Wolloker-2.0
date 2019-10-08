import wollok.game.*

class Jugador inherits CosaInteractiva {

	const property equipo = []
	var property estaVivo = true

	override method image() = self.imagenSegunEquipo()

	method sinEquipo() = equipo.isEmpty()

	method tieneArmadura() = equipo.contains(armadura)

	method tieneEspada() = equipo.contains(espada)

	method tieneCasco() = equipo.contains(casco)

	method tieneEscudo() = equipo.contains(escudo)

	method espadaYArmadura() = self.tieneArmadura() and self.tieneEspada()

	method fullEquipoSinEscudo() = self.espadaYArmadura() and self.tieneCasco()

	method fullEquipoConEscudo() = self.espadaYArmadura() and self.tieneCasco() and self.tieneEscudo()

	method tieneLlave() = equipo.contains(llave)

	method cantEquipo() = equipo.size()

	method solo1Equipo() {
		return if (self.tieneArmadura()) {
			self.soloArmadura()
		} else {
			if (self.tieneEspada()) {
				self.soloEspada()
			} else {
				if (self.tieneEscudo()) {
					self.soloEscudo()
				} else {
					self.desequipado()
				}
			}
		}
	}

	method solo2Equipo() {
		return if (self.tieneLlave()) self.solo1Equipo() else self.conEspadaYArmadura()
	}

	method solo3Equipo() {
		return if (not self.fullEquipoConEscudo()) {
			if (self.fullEquipoSinEscudo()) self.fullSinEscudo()
		} else {
			if (self.fullEquipoConEscudo()) self.full()
		}
	}

	method imagenSegunEquipo() {
		return if (not estaVivo) self.casper() else if (self.cantEquipo() == 0) {
			self.desequipado()
		} else {
			if (self.cantEquipo() == 1) {
				self.solo1Equipo()
			} else {
				if (self.cantEquipo() == 2) {
					self.solo2Equipo()
				} else {
					self.solo3Equipo()
				}
			}
		}
	}

	method full() = "playerFull.png"

	method fullSinEscudo() = "playerArmEspCas.png"

	method conEspadaYArmadura() = "playerArmEsp.png"

	method soloEscudo() = "playerEscudo.png"

	method soloArmadura() = "playerArmadura.png"

	method soloEspada() = "playerEspada.png"

	method desequipado() = "playerSinEquipo.png"

	method casper() = "casper.png"

	method morir() {
		game.sound("muerte.mp3")
		estaVivo = false
		self.dejarEquipo()
	}

	method dejarEquipo() {
		equipo.forEach{ objeto => objeto.aparecer()}
		self.tirarTodo()
	}

	method tirarEquipo(elemento) {
		equipo.remove(elemento)
	}

	method tirarTodo() {
		equipo.clear()
	}

	method revivir() {
		if (not estaVivo) {
			estaVivo = true
			self.moverse(self.position().up(1))
		}
	}

	override method teChocasteCon(cosa) {
		if (estaVivo) cosa.teChocasteCon(self)
	}

	method moverse(posicion) {
		if (self.posicionValida(posicion)) self.position(posicion)
	}

	method posicionValida(posicion) {
		return (controladorDeTablero.cosasDejanPasar(posicion) or not estaVivo) and not controladorDeTablero.seVaDelTablero(posicion)
	}

	method teGolpeo() {
		self.morir()
	}

}

object gaston1 inherits Jugador {

	const property derrotados = []

	method derrotasteA(enemy) {
		derrotados.add(enemy)
	}

}

object gaston2 inherits Jugador {

	var siguiendoA = nada

	method copiarEquipo(lista) {
		equipo.addAll(lista)
	}

	method siguiendoA(alguien) {
		siguiendoA = alguien
	}

	method dejarDeSeguir() {
		siguiendoA.dejarDeLlevar()
	}

	method puedeSerLlevado() = estaVivo

	method seguir(posicion) {
		self.position(posicion)
	}

	override method moverse(posicion) {
		super(posicion)
		if (self.posicionValida(posicion)) self.dejarDeSeguir()
	}

	method posRandom() = game.at(2.randomUpTo(14), 2.randomUpTo(13))

	override method teGolpeo() {
		self.moverse(self.position().left(1))
		self.sobrevivio()
	}

	method sobrevivio() {
		if (self.tieneEscudo()) {
			self.perderEscudo()
		} else {
			if (self.fullEquipoSinEscudo()) self.tirarTodo() else self.morir()
		}
	}

	method perderEscudo() {
		self.tirarEquipo(escudo)
		escudo.position(self.posRandom())
		escudo.aparecer()
	}

}

