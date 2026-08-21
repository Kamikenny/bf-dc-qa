import '@testing-library/jest-dom/vitest';
import { setupServer } from 'msw/node'
import pokemonHandlers from '../mocks/pokemon.handlers';
import { afterAll, afterEach, beforeAll } from 'vitest';

// serveur mock via MSW
export const server = setupServer(...pokemonHandlers)

// Lancement automatique du serveur lors des tests
beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())