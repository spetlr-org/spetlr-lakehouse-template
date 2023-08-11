from spetlrtools.testing import DataframeTestCase


class DemoTest(DataframeTestCase):
    def test(self):
        print("This is a demo test!")
        self.assertTrue(False)
