import { createStore } from 'vuex';
import axios from 'axios';

export default createStore({
  state: {
    schools: [],
    isLoading: false,
    currentPage: 0,
    totalPages: 0,
    perPage: 2,
  },
  mutations: {
    setSchools(state, schools) {
      state.schools = schools;
    },
    setLoading(state, isLoading) {
      state.isLoading = isLoading;
    },
    setCurrentPage(state, page) {
      state.currentPage = page;
    },
    setTotalPages(state, totalPages) {
      state.totalPages = totalPages;
    },
    setPerPage(state, perPage) {
      state.perPage = perPage;
    },
  },
  actions: {
    async fetchSchools({ commit, state }, { page = 0, perPage = state.perPage }) {
      commit('setLoading', true);
      try {
        const response = await axios.get('https://api.data.gov/ed/collegescorecard/v1/schools', {
          params: {
            api_key: 'BvKvzPGqt929BesosVq57BgmTvlf7clqw4ajqqUQ',
            fields: 'id,school.name,school.city,school.zip,location',
            page: page,
            per_page: perPage,
          },
        });
        commit('setSchools', response.data.results);
        commit('setTotalPages', Math.ceil(response.data.metadata.total / perPage));
        commit('setCurrentPage', page);
      } catch (error) {
        console.error('Failed to fetch schools:', error);
      } finally {
        commit('setLoading', false);
      }
    },
  },
  getters: {
    schools(state) {
      return state.schools;
    },
    isLoading(state) {
      return state.isLoading;
    },
    currentPage(state) {
      return state.currentPage;
    },
    totalPages(state) {
      return state.totalPages;
    },
    perPage(state) {
      return state.perPage;
    },
  },
});
