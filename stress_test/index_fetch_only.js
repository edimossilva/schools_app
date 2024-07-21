import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  scenarios: {
    index_fetch_only: {
      executor: 'constant-vus',
      vus: 1,
      duration: '30s',
      exec: 'index_fetch_only',
    },
  },
};

export function index_fetch_only() {
  for (let i = 90; i <= 100; i++) {
    http.get(`http://localhost:3000/api/v1/schools/index_fetch_only?page=0&per_page=${i}&school_name_like=university`);
  }
  // sleep(1);
}
