from spetlrtools.testing import DataframeTestCase


class DummyTest(DataframeTestCase):
    def test(self):
        print("Local test succeed!")
        self.assertTrue(True)
