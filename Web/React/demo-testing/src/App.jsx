import './App.css'
import Counter from './components/Counter/Counter'
import Welcome from './components/Welcome/Welcome'

function App() {

  return (
    <>
      <Welcome firstname={'Trou'} lastname={'Duc'}/>
      <Counter />
    </>
  )
}

export default App

