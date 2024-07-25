import axios from 'axios';

const schoolsApi = {
  async fetchSchools(school_name_like, page, per_page) {
    const response = await axios.get(process.env.SCHOOLS_API_URL, {
      params: {
        school_name_like,
        page,
        per_page
      }
    });
    return response.data;
  }
};

export default schoolsApi;
