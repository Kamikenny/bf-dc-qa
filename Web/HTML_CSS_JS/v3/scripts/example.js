console.log("Jeu du pendu !");

//! Récuperation du formulaire dans le DOM de la page
const gameForm = document.getElementById('game-form');
const msgGameForm = document.getElementById('message-game-form');
const displayWord = document.getElementById('le-mot-à-trouver');
const failedLetters = document.getElementById('failed-letters');
const remainingLives = document.getElementById('remaining-lives');
const words = ['Soleil', 'Jupiter', 'Saturne', 'Uranus', 'Neptune', 'Terre', 'Venus', 'Mars', 'Ganymede', 'Titan', 'Mercure', 'Callisto', 'Io', 'Lune', 'Europa', 'Triton', 'Pluton', 'Titania', 'Rhea', 'Oberon', 'Japet', 'Charon', 'Umbriel', 'Ariel', 'Dione', 'Tethys', 'Ceres', 'Vesta', 'Pallas', 'Encelade', 'Miranda', 'Protee', 'Mimas', 'Hyperion', 'Iris', 'Phoebe', 'Janus', 'Epimethee', 'Lutece', 'Promethee', 'Pandore', 'Mathilde', 'Helene', 'Ida', 'Arrokoth', 'Phobos', 'Déimos', 'Tchourioumov-Guerassimenko', 'Hartley 2', 'Sagittarius A'];

//! Variable de stockage
const letterAlreadySubmit = [];
let mysteryWord;
let lettersFound;
let lives = 5;
let randomWordIndex;

//! Setup du jeu
function startGame() {
    // TODO Rendre aleatoire le choix de mot
    randomWordIndex = calculateRandomIndex(words.length)
    mysteryWord = words[randomWordIndex].toUpperCase().split('')
    lettersFound = [' ', '-'];
    // Reset des lettres envoyées
    letterAlreadySubmit.splice(0, letterAlreadySubmit.length);
    // Reset des vies
    lives = 10;
    updateDisplayWord();
    displayFailedLetters();
    updateDisplayLives();
}
startGame();

//! Réaction à la validation du formulaire
gameForm.addEventListener('submit', function (event) {
    // Annulation du comportement par defaut => Refresh
    event.preventDefault();

    // Récuperer la valeur (depuis le form)
    // - La balise "input" via son "name"
    const userInput = gameForm['user-input'];
    // - On lit la valeur contenu
    const letter = userInput.value.toUpperCase();
    console.log(letter);

    // Traitement de la lettre
    if(letter.length !== 1) {
        msgGameForm.textContent = 'La lettre invalide';
    }
    else if(letterAlreadySubmit.includes(letter)) {
        msgGameForm.textContent = `La lettre ${letter} a déjà été proposé ! Boulet ♥`;
    }
    else {
        letterAlreadySubmit.push(letter);
        
        if(checkLetterIsValid(letter)) {
            msgGameForm.textContent = `La lettre ${letter} est dans le mot`;
            updateDisplayWord();
        }
        else {
            msgGameForm.textContent = `La lettre ${letter} n'est pas dans le mot`;
            lives--;
            updateDisplayLives();
            displayFailedLetters();
        }
    }
    
    // Efface la valeur de l'input
    userInput.value = '';
    
    // On continue ?
    if(checkGameOver()) {
        msgGameForm.textContent = `Bravo, vous avez gagné`;
    }
    else if (lives <= 0) {
        msgGameForm.textContent = `Dommage, vous avez perdu`;
        lettersFound = mysteryWord;
        updateDisplayWord();
    }
});

function checkLetterIsValid(letter) {
    if(mysteryWord.includes(letter)) {
        lettersFound.push(letter);
        return true;
    }
    return false;
}

function updateDisplayWord() {
    displayWord.innerHTML = '';

    for(const letter of mysteryWord) {

        // Création d'un balise "span" en JS (Pas afficher)
        const span = document.createElement('span');

        // Moficiation du contenu du "span"
        if(lettersFound.includes(letter)) {
            span.textContent = letter;
        }
        else {
            span.textContent = '_';
        }

        // Ajoute la balise "span" à la balise "p"
        displayWord.append(span);
    }
}

function displayFailedLetters() {
    failedLetters.innerHTML = '';
    
    for (const letter of letterAlreadySubmit) {

        if(lettersFound.includes(letter)) {
            continue;
        }

        // Création d'un balise "span" en JS (Pas afficher)
        const span = document.createElement('span');
            span.textContent = letter + ', ';

        // Ajoute la balise "span" à la balise "p"
        failedLetters.append(span);
    }
}

function updateDisplayLives() {
    remainingLives.textContent = lives
}

function checkGameOver() {
    // Les letters du mots (sans doublon)
    const mysteryWordSet = new Set(mysteryWord);
    const lettersFoundSet = new Set(lettersFound);

    return lettersFoundSet.isSupersetOf(mysteryWordSet);
}

function calculateRandomIndex(listLength) {
    return Math.floor(Math.random() * ((listLength - 1) - 0 + 1) + 0)
}