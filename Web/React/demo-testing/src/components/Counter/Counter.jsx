import { useState } from "react";

export default function Counter() {
    // Variable d'état (React)
    const [count, setCount] = useState(0);

    const handleIncr = () => {
        // Modification de valeur : Evolution
        setCount(count => count + 1);
    };

    const handleReset = () => {
        // Modification de valeur : Changement
        setCount(0);
    }

    return (
        <>
            <p>{count}</p>
            <div>
                <button onClick={handleIncr}>+ 1</button>
                <button onClick={handleReset}>Reset</button>
            </div>
        </>
    );
}