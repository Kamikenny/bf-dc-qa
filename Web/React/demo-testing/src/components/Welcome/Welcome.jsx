import style from './Welcome.module.css';

export default function Welcome({ firstname, lastname }) {

    return (
        <h1 className={style.example}>Bienvenue {firstname} {lastname} !</h1>
    )
}