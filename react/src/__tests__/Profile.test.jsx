/**
 * @jest-environment jsdom
 */

import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import Profile from '../pages/Profile';
import { MemoryRouter } from 'react-router-dom';
import axios from 'axios';

jest.mock('axios');
window.alert = jest.fn();

describe('Profile Page', () => {
  const initialUser = {
    id: 1,
    email: 'test@test.com',
    username: 'testuser',
    avatar_url: null,
  };

  const mockSetUser = jest.fn();

 beforeEach(() => {
  jest.clearAllMocks();

  axios.get.mockResolvedValue({
    data: {
      user: {
        id: 1,
        email: 'test@test.com',
        username: 'testuser',
        avatar_url: null,
      },
    },
  });

  axios.put.mockResolvedValue({
    data: {
      user: {
        id: 1,
        email: 'test@test.com',
        username: 'updateduser',
        avatar_url: null,
      },
    },
  });
});


  it('renders user info', () => {
    render(
      <MemoryRouter>
        <Profile user={initialUser} setUser={mockSetUser} />
      </MemoryRouter>
    );

    expect(screen.getByPlaceholderText(/username/i)).toBeInTheDocument();
    expect(screen.getByPlaceholderText(/email/i)).toBeInTheDocument();
  });

  it('updates user profile on form submit', async () => {
    render(
      <MemoryRouter>
        <Profile user={initialUser} setUser={mockSetUser} />
      </MemoryRouter>
    );

    const usernameInput = screen.getByPlaceholderText(/username/i);
    fireEvent.change(usernameInput, {
      target: { value: 'updateduser' },
    });

    const formButton = screen.getByRole('button', { name: /update profile/i });
    fireEvent.click(formButton);

    await waitFor(() =>
      expect(mockSetUser).toHaveBeenCalledWith({
        id: 1,
        email: 'test@test.com',
        username: 'updateduser',
        avatar_url: null,
      })
    );
  });
});
