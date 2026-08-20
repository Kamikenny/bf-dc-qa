export default function Pokemon({ data }) {

    console.log(data);

    return (
        <div>
            <p>Nom du Pokemon : {data.name}</p>
            <p>Type du Pokemon : {data.types.join(' - ')}</p>
            <p>Statistiques :</p>
            <ul>
                {data.stats.map(stat => (
                    <li key={stat.name}>
                        {stat.name} : {stat.value}
                    </li>
                ))}
            </ul>
            <img src={data.sprites} alt={`Image de ${data.name}`} />
        </div>
    )
}