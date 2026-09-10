FROM ://microsoft.com AS build
WORKDIR /source
COPY payment-service.csproj .
RUN dotnet restore
COPY ..
RUN dotnet publish -c Release -o /app --no-restore
FROM ://microsoft.com
WORKDIR /app
COPY --from=build /app .
RUN addgroup -g 10007 paymentuser && adduser -u 10007 -G paymentuser -D -S paymentuser
RUN chown -R paymentuser:paymentuser /app
USER paymentuser
EXPOSE 8080
CMD ["dotnet" , "payment-service.dll"]