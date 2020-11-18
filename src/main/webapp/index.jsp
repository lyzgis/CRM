<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" +
            request.getServerName() + ":" + request.getServerPort() +
            request.getContextPath() + "/";
%>
<html>
<head>
    <base href="%basePath%">
    <title>CRM-index</title>
</head>
<script type="text/javascript">
    document.location.href="login.jsp";
</script>
<body>

</body>
</html>
