import mtail_store
import unittest
import os

test_dir = os.path.join(os.path.dirname(__file__))


class MediaWikiAccessLogTest(unittest.TestCase):
    def setUp(self):
        self._handler_codes = {
            'php7': 'proxy:unix:/run/php/fpm-www.sock|fcgi://localhost',
            'static': '-'
        }
        self.store = mtail_store.MtailMetricStore(
                os.path.join(test_dir, '../programs/mediawiki_access_log.mtail'),
                os.path.join(test_dir, 'logs/mediawiki_access_log.test'))

    def id_str(self, handler, method='GET', code=200):
        return "handler=%s,method=%s,code=%d" % (
            self._handler_codes[handler],
            method,
            code
        )

    def testByHandler(self):
        """Test requests are correctly divided by handler."""
        s = self.store.get_samples('mediawiki_http_requests_duration_count')
        self.assertIn((self.id_str('php7'), 5), s)
        self.assertIn((self.id_str('static', code=301), 1), s)

    def testByBucket(self):
        """Tests requests are correctly divided by bucket."""
        s = self.store.get_samples('mediawiki_http_requests_duration_bucket')
        req_id = self.id_str('php7') + ',le=0.05'
        self.assertIn((req_id, 2), s)
        req_id = self.id_str('php7') + ',le=0.1'
        self.assertIn((req_id, 3), s)
        # All similar requests are in bucket +inf
        req_id = self.id_str('php7') + ',le=+Inf'
        self.assertIn((req_id, 5), s)
