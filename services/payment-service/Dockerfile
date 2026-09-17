FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source
COPY payment-service.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/sdk:8.0
WORKDIR /app
COPY --from=build /app .
# Create the system group and user using Debian syntax
RUN groupadd --gid 10007 paymentuser \
    && useradd --uid 10007 --gid paymentuser --create-home --shell /bin/bash paymentuser

RUN chown -R paymentuser:paymentuser /app
USER paymentuser
EXPOSE 8080
CMD ["dotnet" , "payment-service.dll"]
