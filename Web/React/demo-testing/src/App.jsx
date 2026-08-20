import './App.css'
import Counter from './components/Counter/Counter'
import Pokemon from './components/Pokemon/Pokemon'
import PokemonRequester from './components/PokemonRequester/PokemonRequester'
import Today from './components/Today/Today'
import Welcome from './components/Welcome/Welcome'

function App() {

  return (
    <>
      <Welcome firstname={'Trou'} lastname={'Duc'} />
      <Today />
      <Counter />
      <PokemonRequester id={25} />
    </>
  )
}

export default App

