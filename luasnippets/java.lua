return {
  s("package", {
    t("package "), f(function()
      local path = vim.fn.expand("%:p:h")
      local package_name = path:gsub(".*/src/main/java/", ""):gsub("/", ".")
      return package_name
    end), t(";")
  }),
  -- Interface Snippet (uses filename for interface name)
  s("interface", {
    t("public interface "), f(function()
      return vim.fn.expand("%:t:r")
    end), t(" {", "\n\t"), 
    i(1),  -- Cursor will be here
    t({"", "}"})
  }),

  -- Enum Snippet (uses filename for enum name)
  s("enum", {
    t("public enum "), f(function()
      return vim.fn.expand("%:t:r")
    end), t(" {", "\n\t"), 
    i(1),  -- Cursor will be here
    t({"", "}"})
  }),

  -- Main Method Snippet
  s("main", {
    t({"public static void main(String[] args) {", "\t"}), 
    i(1),  -- Cursor will be here
    t({"", "}"})
  }),

  -- System.out.println Snippet
  s("sout", {
    t("System.out.println("), i(1, "\"\""), t(");")
  }),

  -- Constructor Snippet (uses filename for class name)
  s("constructor", {
    t("public "), f(function() return vim.fn.expand("%:t:r") end), t("("), i(1), t(") {", "\n\t"), 
    i(2),  -- Cursor will be here
    t({"", "}"})
  }),

  -- Getter Method Snippet
  s("get", {
    t({"public "}), i(1, "Type"), t(" get"), i(2, "PropertyName"), t("() {", "\n\t"), 
    i(3),  -- Cursor will be here
    t({"", "}"})
  }),

  -- Setter Method Snippet
  s("set", {
    t({"public void set"}), i(1, "PropertyName"), t("("), i(2, "Type"), t(" ", rep(1), t(") {", "\n\t"), 
    i(3),  -- Cursor will be here
    t({"", "}"}))
  }),
}
