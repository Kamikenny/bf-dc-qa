import './App.css'
import Counter from './components/Counter/Counter'
import Today from './components/Today/Today'
import Welcome from './components/Welcome/Welcome'

function App() {

  return (
    <>
      <Welcome firstname={'Trou'} lastname={'Duc'}/>
      <Today />
      <Counter />
    </>
  )
}

export default App

