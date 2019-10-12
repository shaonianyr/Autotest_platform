class PageObject:
    driver = None

    def sleep(self, second):
        import time
        if str(second).isdigit():
            time.sleep(int(second))
        else:
            time.sleep(0.5)

    def open_url(self, url):
        self.driver.get(url)

    def max_size(self):
        self.driver.maximize_window()

    def click(self, locator):
        if locator is None:
            return
        else:
            try:
                PageObject.find_element(self.driver, locator).click()
            except:
                raise

    def send_keys(self, locator, value):
        if locator is None:
            return
        if value is None:
            self.clear(locator)
        else:
            PageObject.find_element(self.driver, locator).send_keys(value)

    def clear(self, locator):
        if locator is None:
            return
        PageObject.find_element(self.driver, locator).clear()

    def alert_accept(self):
        self.driver.switch_to.alert().accept()

    def alert_dismiss(self):
        self.driver.switch_to.alert().dismiss()

    def switch_to_window(self, title=None):
        handle = self.driver.current_window_handle
        if title:
            for handle_ in self.driver.window_handles:
                if handle != handle_:
                    self.driver.switch_to.window(handle)
                    if self.driver.title == title:
                        break
            else:
                raise ValueError("未找到标题为：" + title + " 的页面")
        else:
            for handle_ in self.driver.window_handles:
                if handle != handle_:
                    self.driver.switch_to.window(handle)

    def switch_to_frame(self, locator=None):
        if locator:
            self.driver.switch_to.frame(PageObject.find_element(self.driver, locator))
        else:
            self.driver.switch_to.default_content()

    def forward(self):
        self.driver.forward()

    def back(self):
        self.driver.back()

    def refresh(self):
        self.driver.refresh();

    def close(self):
        self.driver.close()

    def quit(self):
        self.driver.quit()

    def select_by_text(self, element, value, visible=False):
        if element is None:
            return
        from selenium.webdriver.support.select import Select
        element = PageObject.find_element(self.driver, element)
        if not visible:
            Select(element).select_by_text(value)
        else:
            Select(element).select_by_visible_text(value)

    @staticmethod
    def find_element(driver, locator, more=False, timeout=20):
        from selenium.webdriver.support.wait import WebDriverWait
        from selenium.webdriver.support import expected_conditions as ec
        from Product.models import Element
        message = locator
        if isinstance(locator, dict):
            locator = (locator.get("by", None), locator.get("locator", None))
            message = locator
        elif isinstance(locator, list) and len(locator) > 2:
            locator = (locator[0], locator[1])
            message = locator
        elif isinstance(locator, Element):
            message = locator.name
            locator = (locator.by, locator.locator)
        elif isinstance(locator, str):
            locator = tuple(locator.split(".", 1))
            message = locator
        else:
            raise TypeError("element参数类型错误: type:" + str(type(locator)))
        try:
            try:
                if more:
                    return WebDriverWait(driver, timeout).until(ec.visibility_of_all_elements_located(locator))
                else:
                    return WebDriverWait(driver, timeout).until(ec.visibility_of_element_located(locator))
            except:
                if more:
                    return WebDriverWait(driver, timeout).until(ec.presence_of_all_elements_located(locator))
                else:
                    return WebDriverWait(driver, timeout).until(ec.presence_of_element_located(locator))
        except Exception:
            raise RuntimeError("找不到元素:" + str(message))

    def move_to_element(self, locator):
        from selenium.webdriver.common.action_chains import ActionChains
        ActionChains(self.driver).move_to_element(self.find_element(self.driver, locator)).perform()
