let ivan = {
	name: "Iván",
	lastName: "Martínez",
	age: 16
}

let anotherIvan = ivan

function birthday(person) {
	person.age++
}

anotherBirthday = function(person) {
	const clone = Object.assign({}, person)
	clone.age++
	return clone
}

//newIvan e Ivan son objetos totalmente distintos que apuntan a distintos puntos de la memoria.
const newIvan = anotherBirthday(ivan)

console.log("La edad del primer objeto Iván es: " + ivan.age)
console.log("La edad del otro objeto Iván es: " + newIvan.age)