import { getToday } from "../../tools/date.tool"

export default function Today() {

    const today = getToday();

    return (
        <p>Aujourd'hui nous sommes le {today.toLocaleDateString("fr-BE", { dateStyle: "full" })}</p>
    )
}