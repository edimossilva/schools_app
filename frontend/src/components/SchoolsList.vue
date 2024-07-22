<template>
  <div class="container mt-5">
    <h1 class="mb-4">School Search</h1>
    <form @submit.prevent="fetchSchools" class="mb-4">
      <div class="mb-3">
        <label for="school_name_like" class="form-label">School Name</label>
        <input type="text" v-model="school_name_like" id="school_name_like" class="form-control" placeholder="Enter school name" />
      </div>
      <div class="row mb-3">
        <div class="col-md-6">
          <label for="page" class="form-label">Page</label>
          <input type="number" v-model="page" id="page" class="form-control" />
        </div>
        <div class="col-md-6">
          <label for="per_page" class="form-label">Per Page</label>
          <input type="number" v-model="per_page" id="per_page" class="form-control" />
        </div>
      </div>
      <button type="submit" class="btn btn-primary w-100">Search</button>
    </form>
    <div class="d-flex justify-content-between mb-4">
      <button class="btn btn-secondary" @click="previousPage" :disabled="page === 0">Previous Page</button>
      <button class="btn btn-secondary" @click="nextPage">Next Page</button>
    </div>
    <div v-if="loading" class="text-center text-primary">Loading...</div>
    <div v-if="error" class="text-center text-danger">{{ error }}</div>
    <div v-if="requestTime !== null" class="card mt-4 mb-4">
      <div class="card-body">
        <p class="card-text">The request took <b>{{ requestTime }}</b> milliseconds.</p>
      </div>
    </div>
    <div v-if="schools.length > 0" class="row">
      <div v-for="school in schools" :key="school.id" class="col-md-4 mb-4">
        <div
          class="card h-100"
          :class="{ 'selected-card': selectedSchool && selectedSchool.external_id === school.external_id }"
          @click="selectSchool(school)"
          style="cursor: pointer;"
        >
          <div class="card-body">
            <h5 class="card-title">{{ school.name }}</h5>
          </div>
        </div>
      </div>
    </div>
    <div v-if="selectedSchool">
      <SchoolMap :school="selectedSchool" />
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import SchoolMap from './SchoolMap.vue';

export default {
  components: {
    SchoolMap
  },
  data() {
    return {
      school_name_like: 'University',
      page: 0,
      per_page: 10,
      schools: [],
      loading: false,
      error: null,
      selectedSchool: null,
      requestTime: null
    };
  },
  methods: {
    async fetchSchools() {
      this.loading = true;
      this.error = null;
      const startTime = performance.now();

      try {
        const response = await axios.get(process.env.SCHOOLS_API_URL, {
          params: {
            school_name_like: this.school_name_like,
            page: this.page,
            per_page: this.per_page
          }
        });
        const endTime = performance.now();
        this.requestTime = (endTime - startTime).toFixed(2);

        this.schools = response.data;
      } catch (error) {
        this.error = 'Failed to fetch schools';
      } finally {
        this.loading = false;
        this.selectSchool(null)
      }
    },
    selectSchool(school) {
      this.selectedSchool = school;
    },
    nextPage() {
      this.page++;
      this.fetchSchools();
    },
    previousPage() {
      if (this.page > 1) {
        this.page--;
        this.fetchSchools();
      }
    }
  }
};
</script>

<style scoped>
.selected-card {
  border: 2px solid blue;
  transform: scale(1.05);
  transition: transform 0.3s;
}
</style>
