import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  scenarios: {
    index_fetch_and_store_on_cache_and_db: {
      executor: 'constant-vus',
      vus: 1,
      duration: '30s',
      exec: 'index_fetch_and_store_on_cache_and_db',
    },
  },
};

export function index_fetch_and_store_on_cache_and_db() {
  for (let i = 90; i <= 100; i++) {
    http.get(`http://localhost:3000/api/v1/schools/index_fetch_and_store_on_cache_and_db?page=0&per_page=${i}&school_name_like=university`);
  }
  // sleep(1);
}
