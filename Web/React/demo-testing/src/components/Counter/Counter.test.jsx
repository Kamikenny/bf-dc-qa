import { render, screen } from "@testing-library/react";
import { describe, expect, test } from "vitest";
import Counter from "./Counter";
import userEvent from "@testing-library/user-event";

describe('Counter component', () => {
    describe('Display of Counter initial state', () => {
        test('Displays initial state: counter is 0', () => {

            // Arrange
            render(<Counter />);
            const elem = screen.getByRole('paragraph');

            // Act

            // Assert
            expect(elem).toHaveTextContent('0')
        });

        test('Displays 2 buttons', () => {

            // Arrange
            render(<Counter />)
            const btns = screen.getAllByRole('button')

            // Act

            // Assert
            expect(btns).toHaveLength(2)
        });
    })

    describe('Behaviour of increment button', () => {
        test('The increment button increments by one', async () => {
            const user = userEvent.setup();

            // Arrange
            render(<Counter />)
            const elem = screen.getByRole('paragraph')
            const plusOneBtn = screen.getByRole('button', { name: '+ 1' })

            // Act
            await user.click(plusOneBtn)

            // Assert
            expect(elem).toHaveTextContent('1')
        });

        test('The increment button\'s "step" behaves as intended', async () => {
            const user = userEvent.setup()
            const stepTest = 20

            // Arrange
            render(<Counter step={stepTest} />)
            const elem = screen.getByRole('paragraph')
            const incrementBtn = screen.getByRole('button', { name: `+ ${stepTest}` })

            // Act
            await user.click(incrementBtn)

            // Assert
            expect(elem).toHaveTextContent(stepTest)

        })
    })

    describe('Behaviour of "Reset" button', () => {

        test('The "Reset" button sets the counter to "0"', async () => {
            const user = userEvent.setup();
            const stepTest = 20

            // Arrange
            render(<Counter step={stepTest} />)
            const elem = screen.getByRole('paragraph')
            const incrementBtn = screen.getByRole('button', { name: `+ ${stepTest}` })
            const resetBtn = screen.getByRole('button', { name: 'Reset' })

            // screen.debug()

            await user.click(incrementBtn);

            // screen.debug()

            // Act
            await user.click(resetBtn)

            // Assert
            expect(elem).toHaveTextContent("0")
        })
    })
})




